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
            column(AmountinWordsG; AmountinWordsG[1])
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Comment1; CommentLine[1])
            {

            }
            column(Comment2; CommentLine[2])
            {

            }
            column(Comment3; CommentLine[3])
            {

            }
            column(Comment4; CommentLine[4])
            {

            }
            column(Comment5; CommentLine[5])
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
                column(Unit_Cost; "Direct Unit Cost")
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
                    LineAmountG := "Purchase Line"."Qty. to Accept" * "Purchase Line"."Direct Unit Cost";
                    DiscountAmt := (LineAmountG * "Purchase Line"."Line Discount %") / 100;
                    VatAmt := (LineAmountG - DiscountAmt) * ("Purchase Line"."VAT %" / 100);
                    TotalLineAmountG := LineAmountG + VatAmt - DiscountAmt;



                end;
            }
            trigger OnPreDataItem()
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
                GLEntryG.Get();
                DiscountAmt := 0;
                GrandTotalG := 0;
                TotalLineAmount := 0;
                CommentLine[1] := '';
                CommentLine[2] := '';
                CommentLine[3] := '';
                CommentLine[4] := '';
                CommentLine[5] := '';
            end;

            trigger OnAfterGetRecord()
            begin

                PurchaseLineG.Reset();
                PurchaseLineG.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLineG.SetRange("Document No.", PurchaseHeader."No.");
                if PurchaseLineG.FindSet() then
                    repeat
                        DiscountAmountG := 0;
                        TotalLineAmount := 0;
                        TotalLineAmount := (PurchaseLineG."Qty. to Accept" * PurchaseLineG."Direct Unit Cost");
                        DiscountAmountG := TotalLineAmount * PurchaseLineG."Line Discount %" / 100;
                        GrandTotalG += (TotalLineAmount - DiscountAmountG) + (TotalLineAmount - DiscountAmountG) * PurchaseLineG."VAT %" / 100;
                    until PurchaseLineG.Next() = 0;


                CheckG.InitTextVariable();
                CheckG.FormatNoText(AmountinWordsG, round(GrandTotalG, 0.01), 'AED');


                VendorG.Get(PurchaseHeader."Buy-from Vendor No.");
                FAXNo := VendorG."Fax No.";
                VATRegNo := VendorG."VAT Registration No.";
                ProjectNameG := '';

                if PurchaseHeader."Shortcut Dimension 1 Code" <> '' then begin
                    DimensionValueG.Get(GLEntryG."Global Dimension 1 Code", PurchaseHeader."Shortcut Dimension 1 Code");
                    ProjectNameG := DimensionValueG.Name;
                end;

                //Comment Section for 5 line
                i := 1;
                PurchCommentLineG.Reset();
                PurchCommentLineG.SetRange("Document Type", PurchCommentLineG."Document Type"::Order);
                PurchCommentLineG.SetRange("No.", PurchaseHeader."No.");
                if PurchCommentLineG.FindSet() then
                    repeat
                        CommentLine[i] := PurchCommentLineG.Comment;
                        i += 1;
                    until (PurchCommentLineG.Next() = 0) or (i = 6);
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
        PurchCommentLineG: record "Purch. Comment Line";
        CheckG: Report Check;
        AmountinWordsG: array[1] of Text;
        CommentLine: array[5] of Text;
        ProjectNameG: Text[50];
        FAXNo: text[30];
        LineAmountG: Decimal;
        TotalLineAmountG: Decimal;
        DiscountAmountG: Decimal;
        GrandTotalG: Decimal;
        TotalLineAmount: Decimal;
        VATRegNo: code[20];
        DiscountAmt: Decimal;
        VatAmt: Decimal;
        i: Integer;
}
