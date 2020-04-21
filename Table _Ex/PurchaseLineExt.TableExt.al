tableextension 50025 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                "Rejected Qty." := 0;
            end;
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            begin
                "Qty To Reject" := 0;
            end;
        }
        field(50000; "Vendor Trade Agreement"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50001; "Qty under delivery"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50002; "Rejected Qty."; Decimal)
        {
            Caption = 'Rejected Qty.';
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(50003; "Qty To Reject"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty To Reject';
            trigger OnValidate()
            begin
                if "Qty. to Receive" < "Qty To Reject" then
                    Error('Rejected Quatity should be less or equal to the Actual Quantity');

            end;
        }
        field(50004; "Qty. to Accept"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            trigger OnValidate()
            var
                ItemL: Record Item;
            begin
                ItemL.get("No.");
                Validate(Quantity, "Qty. to Accept" + ("Qty. to Accept" * ItemL."Tolerance(%)") / 100);
                "Exceed Qty." := ("Qty. to Accept" * ItemL."Tolerance(%)") / 100;
                Validate("Qty. to Receive", "Qty. to Accept");
                Validate("Qty. to Invoice", "Qty. to Accept");
            end;
        }
        field(50005; "Exceed Qty."; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }
    trigger OnAfterInsert()
    begin
        "Rejected Qty." := 0;
    end;
}