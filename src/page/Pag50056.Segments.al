page 50056 "Segments"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = Segment;
    CardPageId = Segments;
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