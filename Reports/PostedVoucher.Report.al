report 50080 "Posted Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './res/PostedVoucher.rdl';
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            column(VoucherDescG; VoucherDescG)
            { }
            column(Entry_No_; "Entry No.")
            { }
            column(CompInfoG_Name; CompInfoG.Name)
            { }
            column(CompInfoG_Logo; CompInfoG.Picture)
            { }
            column(Document_No_; "Document No.")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(G_L_Account_No_; "G/L Account No.")
            { }
            column(G_L_Account_Name; "G/L Account Name")
            { }
            column(Source_No_; "Source No.")
            { }
            column(SourceDescG; SourceDescG)
            { }
            column(Description; Description)
            { }
            column(Debit_Amount; "Debit Amount")
            { }
            column(Credit_Amount; "Credit Amount")
            { }
            column(TotalDebitG; TotalDebitG)
            { }
            column(TotalCreditG; TotalCreditG)
            { }
            column(Amount; Amount)
            { }
            dataitem("Dimension Set Entry"; "Dimension Set Entry")
            {
                DataItemLink = "Dimension Set ID" = field("Dimension Set ID");
                DataItemTableView = where("Dimension Code" = const('PROJECT'));
                CalcFields = "Dimension Value Name";
                column(Dimension_Value_Code; "Dimension Value Code")
                { }
                column(Dimension_Value_Name; "Dimension Value Name")
                { }
            }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Document No." = field("Document No."), "Transaction No." = field("Transaction No.");
                column(Document_No_Cust; CustLedgerEntryG."Document No.")
                { }
                column(Posting_Date_Cust; CustLedgerEntryG."Posting Date")
                { }
                column(Desc_Cust; CustLedgerEntryG.Description)
                { }
                column(Amount__LCY_Cust; ABS("Amount (LCY)"))
                { }
                trigger OnPreDataItem()
                begin
                    //SetRange("Document No.", "Document No.");
                    //SetRange("Transaction No.", "Transaction No.");
                    IF "G/L Entry"."Source Type" <> "G/L Entry"."Source Type"::Customer then
                        SetRange("Entry No.", 0);
                    SetFilter("Cust. Ledger Entry No.", '<>%1', LedgerEntryNoG);
                end;

                trigger OnAfterGetRecord()
                begin
                    CustLedgerEntryG.Get("Cust. Ledger Entry No.")
                end;
            }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "Document No." = field("Document No."), "Transaction No." = field("Transaction No.");
                column(Document_No_Vend; VendLedgerEntryG."Document No.")
                { }
                column(Posting_Date_Vend; VendLedgerEntryG."Posting Date")
                { }
                column(Desc_Vend; VendLedgerEntryG.Description)
                { }
                column(Amount__LCY_Vend; ABS("Amount (LCY)"))
                { }
                trigger OnPreDataItem()
                begin
                    //SetRange("Document No.", "Document No.");
                    //SetRange("Transaction No.", "Transaction No.");
                    IF "G/L Entry"."Source Type" <> "G/L Entry"."Source Type"::Vendor then
                        SetRange("Entry No.", 0);
                    SetFilter("Vendor Ledger Entry No.", '<>%1', LedgerEntryNoG);
                end;

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    VendLedgerEntryG.Get("Vendor Ledger Entry No.");
                end;
            }

            trigger OnAfterGetRecord()
            var
                GenJourBatchL: Record "Gen. Journal Batch";
                CustomerL: Record Customer;
                VendorL: Record Vendor;
                BankAccL: Record "Bank Account";
            begin
                CompInfoG.Get();
                CompInfoG.CalcFields(Picture);
                If "Journal Batch Name" <> '' then begin
                    GenJourBatchL.SetRange(Name, "Journal Batch Name");
                    if GenJourBatchL.FindFirst() then
                        VoucherDescG := GenJourBatchL.Description;
                end else
                    VoucherDescG := Format("Document Type");

                TotalDebitG += "Debit Amount";
                TotalCreditG += "Credit Amount";

                Clear(CustLedgerEntryG);
                Clear(VendLedgerEntryG);
                Clear(LedgerEntryNoG);
                Clear(SourceDescG);
                case "Source Type" of
                    "Source Type"::Customer:
                        begin
                            IF CustomerL.Get("Source No.") then
                                SourceDescG := CustomerL.Name;
                            CustLedgerEntryG.Reset();
                            CustLedgerEntryG.SetRange("Document No.", "Document No.");
                            CustLedgerEntryG.SetRange("Transaction No.", "Transaction No.");
                            CustLedgerEntryG.SetRange("Posting Date", "Posting Date");
                            CustLedgerEntryG.SetRange("Customer No.", "Source No.");
                            if CustLedgerEntryG.FindFirst() then begin
                                LedgerEntryNoG := CustLedgerEntryG."Entry No.";
                                /* DetailCustLedgEntryG.Reset();
                                DetailCustLedgEntryG.SetRange("Document No.", "Document No.");
                                DetailCustLedgEntryG */
                            end;

                        END;
                    "Source Type"::Vendor:
                        begin
                            if VendorL.Get("Source No.") then
                                SourceDescG := VendorL.Name;
                            VendLedgerEntryG.Reset();
                            VendLedgerEntryG.SetRange("Document No.", "Document No.");
                            VendLedgerEntryG.SetRange("Transaction No.", "Transaction No.");
                            VendLedgerEntryG.SetRange("Posting Date", "Posting Date");
                            VendLedgerEntryG.SetRange("Vendor No.", "Source No.");
                            if VendLedgerEntryG.FindFirst() then begin
                                LedgerEntryNoG := VendLedgerEntryG."Entry No.";
                            end;
                        end;
                    "Source Type"::"Bank Account":
                        begin
                            if BankAccL.get("Source No.") then
                                SourceDescG := BankAccL.Name;
                        end;
                end;
            end;

        }
    }


    var
        CompInfoG: Record "Company Information";
        VoucherDescG: Text;
        ProjectDescG: Text;
        DimenSetEntryG: Record "Dimension Set Entry";
        CustLedgerEntryG: Record "Cust. Ledger Entry";
        DetailCustLedgEntryG: Record "Detailed Cust. Ledg. Entry";
        VendLedgerEntryG: Record "Vendor Ledger Entry";
        DetailVendLedgEntryG: Record "Detailed Vendor Ledg. Entry";
        LedgerEntryNoG: Integer;
        TotalDebitG: Decimal;
        TotalCreditG: Decimal;
        SourceDescG: Text;
}