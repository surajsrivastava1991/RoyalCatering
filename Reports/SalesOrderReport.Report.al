report 50000 "Sales Order Report"
{
    UsageCategory = Administration;
    ApplicationArea = all;
    RDLCLayout = './res/SalesOrder.rdl';

    dataset
    {
        dataitem(Sales_Line; "Sales Line")
        {
            DataItemTableView = where("Document type" = filter("Order"));
            RequestFilterFields = "No.";

            column(CompanyDetailsName;
            CompanyDetails.Name)
            {

            }
            column(Document_No; "Document No.")
            { }
            column(No_; "No.")
            { }
            column(SDate; SDate)
            {

            }
            column(EDate; EDate)
            {

            }
            column(Description; Description)
            {

            }
            column(Line_Amount; "Line Amount")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }
            column(Unit_Cost; "Unit Cost")
            {

            }
            column(Unit_of_Measure_Code; "Unit of Measure Code")
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {

            }
            trigger OnPostDataItem()
            begin
                if (SDate <> 0D) and (EDate <> 0D) then
                    SetRange("Posting Date", SDate, EDate);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyDetails.get();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Start Date"; SDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = all;
                        ToolTip = 'Table field';

                    }
                    field("End Date"; EDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = all;
                        ToolTip = 'Table field';

                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        if (SDate = 0D) and (EDate = 0D) then
            Error(DatefilterErr);
    end;

    var
        CompanyDetails: record "Company Information";
        SDate: Date;
        EDate: Date;
        DatefilterErr: Label 'Date filter is mandatory';
}