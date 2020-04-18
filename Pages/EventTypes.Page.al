page 50055 "Event Types"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Event Type";
    CardPageId = "Event Types";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(Code; Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Table field';
                }
            }
        }
    }
}