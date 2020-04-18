table 50003 "Cost Allocation Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "From Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(2; "To Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Bulk Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger OnValidate()
            var
                LocationL: Record Location;
            begin
                if LocationL.Get("Bulk Location") then
                    "Bulk Location Name" := LocationL.Name
                else
                    "Bulk Location Name" := '';
            end;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Bulk Location Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Project No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Recipe Cost"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Allocation %"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Allocated Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Allocated Cost Manual"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "From Date", "To Date", "Bulk Location", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        CostAllocationHeaderG.Reset();
        CostAllocationHeaderG.SetRange("From Date", "From Date");
        CostAllocationHeaderG.SetRange("To Date", "To Date");
        CostAllocationHeaderG.SetRange("Bulk Location", "Bulk Location");
        if CostAllocationHeaderG.FindFirst() then
            if CostAllocationHeaderG."Journal Posted" then
                Error('You cannot modify the cost allocation, because journal has been posted ')
            else begin
                CostAllocationHeaderG."Journal Created" := false;
                CostAllocationHeaderG."Voucher No.(Pre)" := '';
                CostAllocationHeaderG.Modify(true);
            end;
    end;

    trigger OnDelete()
    begin
        CostAllocationHeaderG.Reset();
        CostAllocationHeaderG.SetRange("From Date", "From Date");
        CostAllocationHeaderG.SetRange("To Date", "To Date");
        CostAllocationHeaderG.SetRange("Bulk Location", "Bulk Location");
        if CostAllocationHeaderG.FindFirst() then
            if CostAllocationHeaderG."Journal Posted" then
                Error('You cannot delete the cost allocation, because journal has been posted ');
    end;

    trigger OnRename()
    begin

    end;

    var
        CostAllocationHeaderG: Record "Cost Allocation Header";
}