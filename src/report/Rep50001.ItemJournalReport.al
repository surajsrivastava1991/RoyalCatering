report 50001 "Item Journal Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/ItemJournal.rdl';

    dataset
    {
        dataitem("Item Journal Line"; "Item Journal Line")
        {
            column(CompanyDetailsName;
            CompanyDetails.Name)
            {

            }
            column(Document_No; "Document No.")
            { }
            column(No_; "Item No.")
            { }
            column(Document_Date; "Document Date")
            {

            }
            column(Line_No_; "Line No.")
            {

            }

            column(Description; Description)
            {

            }
            column(Amount; "Amount")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Location_Code; "Location Code")
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

            trigger OnAfterGetRecord()
            begin
                CompanyDetails.get();
            end;
        }
    }

    var
        CompanyDetails: record "Company Information";
}