page 50067 "Locationwise Purchasers"
{
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
                field("Item Category Code"; "Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Table Fields';
                }
                field("Purchaser Code"; "Purchaser Code")
                {
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