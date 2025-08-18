// ===============================
// Healthcare Billing Analysis (Power Query M)
// Author: Curtis Kingery
// ===============================

// ---------- Parameters (optional) ----------
let
    // Update the CSV path as needed when importing into Excel/Power BI
    CsvPath = "healthcare_dataset.csv"
in  CsvPath

// ---------- Base Query: FactBilling ----------
// Source table with typed columns and engineered LOS
let
    Source = Csv.Document(File.Contents(CsvPath),[Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    PromoteHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    TrimText = Table.TransformColumns(PromoteHeaders, List.Transform(
        Table.ColumnNames(PromoteHeaders),
        (c) => {c, each try Text.Trim(_) otherwise _, type nullable text}
    )),

    // Coerce likely types (edit column names as needed)
    Typed = Table.TransformColumnTypes(TrimText,{
        {"PatientID", type text},
        {"Gender", type text},
        {"Insurer", type text},
        {"Hospital", type text},
        {"IssueType", type text},
        {"ArrivalDate", type date},
        {"DepartureDate", type date},
        {"BillingAmount", type number}
    }),

    // Length of Stay in days
    AddLOS = Table.AddColumn(Typed, "LOS_Days", each Duration.Days([DepartureDate] - [ArrivalDate]), Int64.Type),

    // Month bucket for time series
    AddMonth = Table.AddColumn(AddLOS, "MonthStart", each Date.StartOfMonth([ArrivalDate]), type date),

    // Clean categorical text to avoid accidental blanks/whitespace
    CleanCats = Table.TransformColumns(AddMonth, {
        {"Gender", each if _ = null then "Unknown" else Text.Proper(Text.Trim(_)), type text},
        {"Insurer", each if _ = null then "Unknown" else Text.Proper(Text.Trim(_)), type text},
        {"Hospital", each if _ = null then "Unknown" else Text.Proper(Text.Trim(_)), type text},
        {"IssueType", each if _ = null then "Unknown" else Text.Proper(Text.Trim(_)), type text}
    })
in
    CleanCats

// ---------- Helper: GroupStats function ----------
// Returns Sum, Average, Median, Count of BillingAmount by a single column
(groupTable as table, keyColumn as text) as table =>
let
    Grouped = Table.Group(
        groupTable,
        { keyColumn },
        {
            {"Billing_Sum",    each List.Sum([BillingAmount]),    type nullable number},
            {"Billing_Avg",    each List.Average([BillingAmount]),type nullable number},
            {"Billing_Median", each List.Median([BillingAmount]), type nullable number},
            {"Row_Count",      each Table.RowCount(_),            Int64.Type}
        }
    ),
    // Optional: sort by sum desc
    Sorted = Table.Sort(Grouped, {{"Billing_Sum", Order.Descending}})
in
    Sorted

// ---------- Views: Categorical Groupings ----------
// By Gender
let
    ByGender = GroupStats(FactBilling, "Gender")
in
    ByGender

// By Insurer
let
    ByInsurer = GroupStats(FactBilling, "Insurer")
in
    ByInsurer

// By Hospital
let
    ByHospital = GroupStats(FactBilling, "Hospital")
in
    ByHospital

// By Issue Type
let
    ByIssueType = GroupStats(FactBilling, "IssueType")
in
    ByIssueType

// ---------- Time Series: Monthly Totals ----------
let
    MonthlyTotals = Table.Group(
        FactBilling,
        {"MonthStart"},
        {{"Billing_Sum", each List.Sum([BillingAmount]), type number}}
    ),
    MonthlySorted = Table.Sort(MonthlyTotals, {{"MonthStart", Order.Ascending}})
in
    MonthlySorted

// ---------- Time Series: Monthly by Gender (Pivot) ----------
let
    MonthGender = Table.Group(
        FactBilling,
        {"MonthStart", "Gender"},
        {{"Billing_Sum", each List.Sum([BillingAmount]), type number}}
    ),
    Pivot = Table.Pivot(
        MonthGender,
        List.Distinct(MonthGender[Gender]),
        "Gender",
        "Billing_Sum",
        List.Sum
    ),
    MonthGenderSorted = Table.Sort(Pivot, {{"MonthStart", Order.Ascending}})
in
    MonthGenderSorted
