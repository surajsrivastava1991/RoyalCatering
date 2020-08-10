page 50074 "Maintenance Service List"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Maintenance Service Header";
    CardPageId = "Maintenance Service Order";
    Caption = 'Maintenance Service List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("MRO No."; "MRO No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Asset ID"; "Asset ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Asset Description"; "Asset Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Duration From"; "Duration From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Equipment; Equipment)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field("Duration To"; "Duration To")
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }
    }
}