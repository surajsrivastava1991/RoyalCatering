page 50009 "Cash Receipt Jnl. Templates"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Cash Receipt - Jnl. Batch Templates';
    PageType = List;
    PromotedActionCategories = 'New,Process,Page,Navigate';
    SourceTable = "Gen. Journal Template";
    SourceTableView = sorting(Name) where("Custumised Jnl." = const(true), Type = const("Cash Receipts"));
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal template you are creating.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a brief description of the journal template you are creating.';
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the journal type. The type determines what the window will look like.';
                }

                field("Batch Decription"; "Batch Description")
                {
                    ApplicationArea = all;
                    ToolTip = 'Batch Decription';
                }

            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(Batches)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Batches';
                Image = Description;
                RunObject = Page "Custumised Genl Jnl. Batches";
                RunPageView = WHERE("approval status" = filter(open | Canceled | Rejected | Approved));
                RunPageLink = "Journal Template Name" = FIELD(Name);
                ToolTip = 'View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.';
            }

        }
    }
}

