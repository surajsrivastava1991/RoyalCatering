report 50005 "Product Receipt Summary"
{
    Caption = 'Product Receipt Summary';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './res/ProductReceiptSummaryLayout.rdl';
    dataset
    {
        dataitem(Purch_Rcpt_Header; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "Posting Date";
            column(SlNoVar; SlNoVar)
            {

            }
            column(No_; "No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Vendor_Shipment_No_; "Vendor Shipment No.")
            {

            }
            column(DateOfCreationVar; CreationDateTime)
            {

            }
            column(CreatedByVar; CreatedByVar)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(RequestFiltersVar; RequestFiltersVar)
            {

            }
            column(CreationDateFilterVar; CreationDateFilterVar)
            {

            }
            trigger OnAfterGetRecord()
            begin
                Clear(DateOfCreationVar);
                Clear(TimeOfCreationVar);
                Clear(CreatedByVar);
                Clear(CreationDateTime);
                ItemLEdgEntry.Reset();
                ItemLEdgEntry.SetCurrentKey("Document No.");
                ItemLEdgEntry.SetRange("Document No.", "No.");
                ItemLEdgEntry.SetRange("Posting Date", "Posting Date");
                if ItemLEdgEntry.FindFirst() then begin
                    ItemRegisterG.Reset();
                    ItemRegisterG.SetCurrentKey("From Entry No.");
                    ItemRegisterG.SetRange("From Entry No.", ItemLEdgEntry."Entry No.");
                    if ItemRegisterG.FindFirst() then begin
                        if (FromDate <> 0D) and (ToDate <> 0D) then
                            if not ((ItemRegisterG."Creation Date" >= FromDate) and (ItemRegisterG."Creation Date" <= ToDate)) then
                                CurrReport.Skip();
                        DateOfCreationVar := ItemRegisterG."Creation Date";
                        TimeOfCreationVar := ItemRegisterG."Creation Time";
                        CreationDateTime := CreateDateTime(DateOfCreationVar, TimeOfCreationVar);
                        CreatedByVar := ItemRegisterG."User ID";
                    end;
                end else
                    CurrReport.Skip();
                SlNoVar += 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Creation Date")
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CreationDateFilterVar := '';
        RequestFiltersVar := '';
        SlNoVar := 0;
        RequestFiltersVar := Purch_Rcpt_Header.GetFilters();
        if not ((FromDate = 0D) and (ToDate = 0D)) then
            CreationDateFilterVar := 'Creation Date: ' + Format(FromDate) + ' to ' + Format(ToDate);
    end;

    var
        ItemRegisterG: Record "Item Register";
        ItemLEdgEntry: Record "Item Ledger Entry";
        DateOfCreationVar: Date;
        CreationDateTime: DateTime;
        TimeOfCreationVar: Time;
        CreatedByVar: Code[50];
        SlNoVar: Integer;
        FromDate: Date;
        ToDate: Date;
        RequestFiltersVar: Text[250];
        CreationDateFilterVar: Text[100];


}