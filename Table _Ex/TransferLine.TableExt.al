tableextension 50123 "Transfer Line" extends "Transfer Line"
{
    fields
    {
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                itemL: Record Item;
            begin
                if itemL.get("Item No.") then
                    "Unit Cost" := itemL."Unit Cost"
                else
                    "Unit Cost" := 0;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                TotalAmountCalculation();
            end;
        }
        modify("Unit of Measure Code")
        {
            trigger OnAfterValidate()
            var
                ItemUOML: Record "Item Unit of Measure";
                ItemL: Record Item;
            begin
                //Suraj 26/06/20
                if ItemL.get("Item No.") and ("Unit of Measure Code" <> '') then begin
                    ItemUOML.Reset();
                    ItemUOML.SetRange("Item No.", "Item No.");
                    ItemUOML.SetRange(Code, "Unit of Measure Code");
                    if ItemUOML.FindFirst() then
                        "Unit Cost" := ItemL."Unit Cost" * ItemUOML."Qty. per Unit of Measure";

                    TotalAmountCalculation();
                end;
            end;

        }
        field(50000; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50001; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

    }

    var
        myInt: Integer;

    procedure TotalAmountCalculation()
    begin
        if Quantity <> 0 then
            "Total Amount" := Quantity * "Unit Cost";
    end;
}