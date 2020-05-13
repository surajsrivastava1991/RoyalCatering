report 50003 "Purchase Order Details"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = './res/PurchaseOrderDetails.rdl';
    Caption = 'Purchase Order Details';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(Comp_Name; CompInfoG.Name)
            { }
            column(Logo; CompInfoG.Picture)
            { }
            column(CompInfoGAdd; CompInfoG.Address)
            {

            }
            column(VATRegCompInfoG; CompInfoG."VAT Registration No.")
            {

            }
            column(No; "No.")
            {
            }

            column(BuyfromVendorName; "Buy-from Vendor Name")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(BuyfromContactNo; "Buy-from Contact No.")
            {
            }
            column(BuyfromCountryRegionCode; "Buy-from Country/Region Code")
            {
            }
            column(BuyfromPostCode; "Buy-from Post Code")
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
            column(VendorShipmentNo; "Vendor Shipment No.")
            {
            }
            column(VendorOrderNo; "Vendor Order No.")
            {
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
            }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ReceivingNo; "Receiving No.")
            {
            }
            column(QuoteNo; "Quote No.")
            {
            }
            column(Amount_Including_VAT; "Amount Including VAT")
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
            column(Payment_Discount__; "Payment Discount %")
            {

            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {

            }
            column(Buy_from_Contact_No_; "Buy-from Contact No.")
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(No_; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; "Qty. to Accept")
                {

                }
                column(Unit_Cost; "Unit Cost")
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(Line_Amount; LineAmountG)
                {

                }
                column(Line_Discount__; "Line Discount %")
                {

                }
                column(Line_Discount_Amount; DiscountAmt)
                {

                }
                column(VAT_Base_Amount; LineAmountG)
                {

                }
                column(Line_No_; "Line No.")
                {

                }
                column(AmountinWordsG; AmountinWordsG[1])
                {

                }
                column(LocationCode; "Location Code")
                {
                }
                column(DiscountAmt; DiscountAmt)
                {

                }
                column(VatAmt; VatAmt)
                {

                }

                trigger OnAfterGetRecord()
                begin
                    // QuantityG := "Purchase Line"."Qty. to Accept";
                    LineAmountG := "Purchase Line"."Qty. to Accept" * "Purchase Line"."Unit Cost";
                    DiscountAmt := (LineAmountG * "Purchase Line"."Line Discount %") / 100;
                    VatAmt := LineAmountG * ("Purchase Line"."VAT %" / 100);
                    TotalLineAmountG := LineAmountG + VatAmt - DiscountAmt;
                    GrandTotalG += LineAmountG + VatAmt;
                    CheckG.InitTextVariable();
                    CheckG.FormatNoText(AmountinWordsG, GrandTotalG, 'AED');


                end;
            }
            trigger OnPreDataItem()
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
                GLEntryG.Get();
                DiscountAmt := 0;
                GrandTotalG := 0;
            end;

            trigger OnAfterGetRecord()
            begin

                // PurchaseLineG.Reset();
                // PurchaseLineG.SetRange("Document Type", PurchaseHeader."Document Type");
                // PurchaseLineG.SetRange("Document No.", PurchaseHeader."No.");
                // if PurchaseLineG.FindSet() then
                //     repeat
                //         GrandTotalG += (PurchaseLineG."Qty. to Accept" * PurchaseLineG."Unit Cost") * (1 + (PurchaseLineG."VAT %" / 100) - (PurchaseLineG."Line Discount %") / 100);
                //     until PurchaseLineG.Next() = 0;





                VendorG.Get(PurchaseHeader."Buy-from Vendor No.");
                FAXNo := VendorG."Fax No.";
                VATRegNo := VendorG."VAT Registration No.";
                ProjectNameG := '';

                if PurchaseHeader."Shortcut Dimension 1 Code" <> '' then begin
                    DimensionValueG.Get(GLEntryG."Global Dimension 1 Code", PurchaseHeader."Shortcut Dimension 1 Code");
                    ProjectNameG := DimensionValueG.Name;
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
        VendorG: Record Vendor;
        PurchaseLineG: Record "Purchase Line";

        CheckG: Report Check;
        AmountinWordsG: array[1] of Text;

        ProjectNameG: Text[50];
        FAXNo: text[30];
        LineAmountG: Decimal;
        TotalLineAmountG: Decimal;
        GrandTotalG: Decimal;
        VATRegNo: code[20];
        DiscountAmt: Decimal;
        VatAmt: Decimal;
}
