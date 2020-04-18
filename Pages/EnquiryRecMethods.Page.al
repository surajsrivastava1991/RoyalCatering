page 50057 "Enquiry Rec. Methods"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Method Of Receiving Enq.";
    // CardPageId = "Event Types";
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