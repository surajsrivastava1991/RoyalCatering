tableextension 50083 GenJnlTemplate extends "Gen. Journal Template"
{
    fields
    {
        modify("Page ID")
        {
            trigger OnBeforeValidate()
            begin
                testfield("Custumised Jnl.", false);
            end;
        }
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                if "Custumised Jnl." then
                    case type of
                        type::General:
                            "Page ID" := page::"Custumised General Journal";
                        type::Payments:
                            "Page ID" := page::"Custumised Payment - Journal";
                        type::"Cash Receipts":
                            "Page ID" := page::"Cust. Cash Receipt - Journal";
                    end;
            end;
        }
        field(60000; "Batch No. Series"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch No.Series';
            TableRelation = "No. Series";
        }

        field(60001; "Custumised Jnl."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Custumised Jnl.';
            trigger OnValidate()
            begin
                if "Custumised Jnl." then begin
                    if not ((type = type::General) or (type = type::Payments) or (Type = Type::"Cash Receipts")) then
                        error('Type must be General/Payment/Cash Receipt');
                    case type of
                        type::General:
                            "Page ID" := page::"Custumised General Journal";
                        type::Payments:
                            "Page ID" := page::"Custumised Payment - Journal";
                        type::"Cash Receipts":
                            "Page ID" := page::"Cust. Cash Receipt - Journal";
                    end;
                end else
                    validate(Type);
            end;
        }
        field(60002; "Batch Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch Description';
        }
        field(60003; "Allow Multiple Voucher"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Allow Multiple Voucher';
        }
    }
}