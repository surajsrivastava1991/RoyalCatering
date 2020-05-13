page 50020 "Breakdown Monitoring Log"
{
    Caption = 'Maintenance Service Log';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Maintenance Service Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("MRO No."; "MRO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Asset ID"; "Asset ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Duration From"; "Duration From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Duration To"; "Duration To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Equipment; Equipment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Location Name"; "Location Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Break Duration"; "Break Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Details; Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Consequnces; Consequnces)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Correction Action Plan"; "Correction Action Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Preventive action plan"; "Preventive action plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Material Cost"; MaterialCostVar)
                {
                    Caption = 'Material Cost';
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("ManPower Cost"; "ManPower Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("LPO No."; "LPO No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        MaterialCostVar := 0;
        MantananceSerLineG.Reset();
        MantananceSerLineG.SetAutoCalcFields("Cost Amount(Actual)");
        MantananceSerLineG.SetRange("MRO No.", "MRO No.");
        if MantananceSerLineG.FindSet() then
            repeat
                MaterialCostVar += MantananceSerLineG."Cost Amount(Actual)";
            until MantananceSerLineG.Next() = 0;
        MaterialCostVar := -(MaterialCostVar);
    end;

    var
        MantananceSerLineG: Record "Maintenance Service Line";
        MaterialCostVar: Decimal;
}