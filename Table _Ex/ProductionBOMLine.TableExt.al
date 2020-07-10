tableextension 50103 "Production BOM Line" extends "Production BOM Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemL: Record Item;
            begin
                if ItemL.get("No.") then
                    if ItemL."Production Unit of Measure" <> '' then
                        "Unit of Measure Code" := ItemL."Production Unit of Measure"
            end;
        }
    }

    var
        myInt: Integer;
}