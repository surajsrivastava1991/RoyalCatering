report 50015 "Facility Management"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/FacilityManagement.rdl';
    Caption = 'Facility Management';


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
            column(Invocie_Description; "Invoice Description")
            {

            }
            column(VATRegCompInfoG; CompInfoG."VAT Registration No.")
            {

            }
            column(CompInfoGRegion; CompInfoG."Country/Region Code")
            {

            }
            column(CompInfoG_SwiftCode; CompInfoG."SWIFT Code")
            {

            }
            column(CompInfoG_BankAddress; CompInfoG."Bank Address")
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
            column(CompInfoG_BankName; CompInfoG."Bank Name")
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

            column(BuyfromVendorName; ContactName)
            {
            }
            column(Ship_to_Address_2; Address2)
            {
            }
            column(Ship_to_Address; Address1)
            {
            }
            column(BuyfromContactNo; PhoneNo)
            {
            }
            column(BuyfromCountryRegionCode; CountryRegion)
            {
            }
            column(BuyfromPostCode; PostCode)
            {
            }
            column(Ship_to_City; City)
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
            column(Your_Reference; "Your Reference")
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
            column(Inv_Amount_Including_VAT; "Amount Including VAT")
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
                column(Inv__Discount_Amount; "Inv. Discount Amount")
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                column(GrossAmountG; GrossAmountG)
                {

                }
                column(Days; Days)
                {

                }
                column(Monthly_Charges; "Monthly Charges")
                {

                }
                column(Manday_Unit_Price; "Manday Unit Price")
                {

                }

                trigger OnAfterGetRecord()
                begin
                    GrossAmountG := "Sales Invoice Line".Quantity * "Sales Invoice Line"."Unit Price";
                    SNo += 1;
                end;
            }
            trigger OnPreDataItem()
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
                GLEntryG.Get();
                DiscountAmt := 0;
                GrossAmountG := 0;
                SNo := 0;

            end;

            trigger OnAfterGetRecord()
            begin
                CalcFields(Amount);
                CalcFields("Amount Including VAT");
                PEDate := 0D;
                PSDate := 0D;
                CheckG.InitTextVariable();
                CheckG.FormatNoText(AmountinWordsG, SalesInvoiceHeader."Amount Including VAT", 'AED');
                if CustomerG.Get(SalesInvoiceHeader."Bill-to Customer No.") then begin
                    FAXNo := CustomerG."Fax No.";
                    VATRegNo := CustomerG."VAT Registration No.";
                    EmailG := CustomerG."E-Mail";
                    ProjectNameG := '';
                    PhoneNo := CustomerG."Phone No.";
                    ContactName := CustomerG.Name;

                    if SalesInvoiceHeader."shortcut Dimension 1 Code" <> '' then begin
                        DimensionValueG.Get(GLEntryG."Global Dimension 1 Code", SalesInvoiceHeader."shortcut Dimension 1 Code");
                        ProjectNameG := DimensionValueG.Name;
                    end;
                end;

                if SalesInvoiceHeader."Bill-to Contact No." <> '' then begin
                    ContactG.Reset();
                    ContactG.SetRange("No.", SalesInvoiceHeader."Bill-to Contact No.");
                    if ContactG.FindFirst() then begin
                        ContactName := ContactG.Name;
                        PhoneNo := ContactG."Phone No.";
                        FAXNo := ContactG."Fax No.";
                        EmailG := ContactG."E-Mail";
                        Address1 := ContactG.Address;
                        Address2 := ContactG."Address 2";
                        City := ContactG.City;
                        PostCode := ContactG."Post Code";
                        CountryRegion := ContactG."Country/Region Code";
                    end;
                end else begin
                    // ContactName := "Bill-to Name";
                    Address1 := "Bill-to Address";
                    Address2 := "Bill-to Address 2";
                    City := "Bill-to City";
                    PostCode := "Bill-to Post Code";
                    CountryRegion := "Bill-to Country/Region Code";
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
        ContactG: Record Contact;

        CheckG: Report Check;
        AmountinWordsG: array[1] of Text;

        ProjectNameG: Text[50];
        FAXNo: text[30];
        VATRegNo: code[20];
        EmailG: Text[200];
        Address1: Text[250];
        Address2: Text[250];
        City: Code[30];
        PostCode: Code[20];
        CountryRegion: Code[20];
        ContactName: Text[100];
        PhoneNo: Code[30];
        DiscountAmt: Decimal;
        GrossAmountG: Decimal;
        PSDate: Date;
        PEDate: Date;
        SNo: Integer;
}
