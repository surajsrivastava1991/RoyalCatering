page 50067 "Locationwise Purchasers"
{
    Caption = 'Requisition user setup';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Locationwise Purchaser";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Requisition Type"; "Requisition Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    Caption = 'Assigned User ID';
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}