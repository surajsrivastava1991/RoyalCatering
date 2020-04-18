tableextension 50030 "Sales Line Ex" extends "Sales Line"
{
    fields
    {
        modify("Shipment Date")
        {
            trigger OnAfterValidate()
            begin
                if SalesHeaderL.Get("Document Type", "Document No.") then
                    if SalesHeaderL."Type of Sale" IN [SalesHeaderL."Type of Sale"::"Events", SalesHeaderL."Type of Sale"::"Contract", SalesHeaderL."Type of Sale"::"Facility Management", SalesHeaderL."Type of Sale"::"Contract-Event"] then
                        if ("Shipment Date" > SalesHeaderL."Date of function end") or ("Shipment Date" < CalcDate('<-1D>', SalesHeaderL."Date of function start")) then
                            Error('Shipment Date Should be with the range of Date of function start %1 or Date of function End %2', CalcDate('<-1D>', SalesHeaderL."Date of function start"), SalesHeaderL."Date of function end");
            end;
        }
        field(50000; "Production Line Created"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist ("Production Plan Header" where("BEO No." = field("Document No."), "BEO Line No." = field("Line No.")));
            Editable = false;
        }
        // Add changes to table fields here
    }

    var
        SalesHeaderL: record "Sales Header";
}