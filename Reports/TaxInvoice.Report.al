report 50002 "Tax Invoice"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/TaxInvoice.rdl';
    Caption = 'Tax Invoice';

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
            column(Comp_Name; CompInfoG.Name)
            { }
            column(Logo; CompInfoG.Picture)
            { }
            column(CompInfoGAdd; CompInfoG.Address)
            {

            }
            column(CompInfoG; CompInfoG."Address 2")
            {

            }
            column(Posting_Description; "Posting Description")
            {

            }
            column(Work_Description; workDescriptionG)
            {

            }
            column(VATRegCompInfoG; CompInfoG."VAT Registration No.")
            {

            }
            column(CompInfoGRegion; CompInfoG."Country/Region Code")
            {

            }
            column(CompInfoGPostCode; CompInfoG."Post Code")
            { }
            column(CompInfoGCity; CompInfoG.City)
            { }
            column(CompInfoGEmail; CompInfoG."E-Mail")
            { }
            column(CompInfoGfax; CompInfoG."Fax No.")
            {

            }
            column(CompInfoGPhone; CompInfoG."Phone No.")
            {

            }
            column(CompInfoGAcNo; CompInfoG."Bank Account No.")
            { }
            column(CompInfoGBranchNo; CompInfoG."Bank Branch No.")
            { }
            column(CompInfoGIBAN; CompInfoG.IBAN)
            { }
            column(No; "No.")
            {
            }

            column(BuyfromVendorName; "Bill-to Name")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(BuyfromContactNo; "Bill-to Contact No.")
            {
            }
            column(BuyfromCountryRegionCode; "Bill-to Country/Region Code")
            {
            }
            column(BuyfromPostCode; "Bill-to Post Code")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {

            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(VATBaseDiscount; "VAT Base Discount %")
            {
            }
            column(Amount; Amount)
            {
            }
            column(VendorShipmentNo; "Opportunity No.")
            {
            }
            column(VendorOrderNo; "Order No.")
            {
            }
            column(VendorInvoiceNo; "No.")
            {
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ReceivingNo; "Order No.")
            {
            }
            column(QuoteNo; "Quote No.")
            {
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {

            }
            column(AmountinWordsG; AmountinWordsG[1])
            {

            }
            column(ProjectNameG; ProjectNameG)
            {

            }
            column(FAXNo; FAXNo)
            {

            }
            column(Order_Date; "Order Date")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            column(VATRegNo; VATRegNo)
            {

            }
            column(PSDate; PSDate)
            { }
            column(PEDate; PEDate)
            { }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {

            }
            column(Email; EmailG)
            {

            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(No_; SNo)
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_Cost; "Unit Price")
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Line_Discount_Amount; "Line Discount Amount")
                {

                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(Line_No_; "Line No.")
                {

                }
                column(LocationCode; "Location Code")
                {
                }
                column(DiscountAmt; DiscountAmt)
                {

                }
                column(VatAmountG; VatAmountG)
                {

                }

                trigger OnAfterGetRecord()
                begin
                    DiscountAmt += "Sales Invoice Line"."Line Discount Amount";
                    VatAmountG := "Sales Invoice Line"."Line Amount" * "Sales Invoice Line"."VAT %" / 100;
                    SNo += 1;
                end;
            }
            trigger OnPreDataItem()
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
                GLEntryG.Get();
                DiscountAmt := 0;
                SNo := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                PEDate := 0D;
                PSDate := 0D;
                CheckG.InitTextVariable();
                CheckG.FormatNoText(AmountinWordsG, SalesInvoiceHeader."Amount Including VAT", 'AED');
                Evaluate("Work Description", workDescriptionG);
                if CustomerG.Get(SalesInvoiceHeader."Bill-to Customer No.") then begin
                    FAXNo := CustomerG."Fax No.";
                    VATRegNo := CustomerG."VAT Registration No.";
                    EmailG := CustomerG."E-Mail";
                    ProjectNameG := '';

                    if CustomerG."global Dimension 1 Code" <> '' then begin
                        DimensionValueG.Get(GLEntryG."Global Dimension 1 Code", CustomerG."global Dimension 1 Code");
                        ProjectNameG := DimensionValueG.Name;
                    end;
                end;

            end;

        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CompInfoG: Record "Company Information";
        DimensionValueG: Record "Dimension Value";
        GLEntryG: record "General Ledger Setup";
        CustomerG: Record Customer;

        CheckG: Report Check;
        AmountinWordsG: array[1] of Text;

        ProjectNameG: Text[50];
        FAXNo: text[30];
        VATRegNo: code[20];
        EmailG: Text[200];
        workDescriptionG: Text[250];
        DiscountAmt: Decimal;
        VatAmountG: Decimal;
        PSDate: Date;
        PEDate: Date;
        SNo: Integer;
}
