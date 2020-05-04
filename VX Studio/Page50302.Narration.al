page 50092 "Narration"
{
    PageType = Worksheet;
    SourceTable = Narration;
    DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            field("Document No."; "Document No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            Repeater(group)
            {
                field(Narration; Narration)
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        myInt: Integer;
}