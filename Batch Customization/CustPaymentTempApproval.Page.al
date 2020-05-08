page 50010 "Cust. Payment Temp. Approval"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment - Journal Batch Temp. - Approval';
    PageType = List;
    SourceTable = "Gen. Journal Template";
    SourceTableView = sorting(Name) where("Custumised Jnl." = const(true), Type = const(Payments));
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
        area(Processing)
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
                RunPageLink = "Journal Template Name" = FIELD(Name);
                ToolTip = 'View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.';
            }

        }
    }
}

