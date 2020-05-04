page 50093 "Posted Narration"
{
    PageType = List;
    SourceTable = "Posted Narration";
    Editable = false;

    layout
    {
        area(Content)
        {
            Repeater(group)
            {
                field(Narration; Narration)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}