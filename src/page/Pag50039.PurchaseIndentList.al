page 50039 "Purchase Indent List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Indent Header";
    CardPageId = "Purchase Indent Card";
    Caption = 'Purchase Requisitions';
    SourceTableView = where("Replenishment Type" = CONST(1));
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No.';
                }
                field(Details; Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Details';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name';
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval Status';
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("Line")
            {
                Caption = 'Attachment';
                Image = Attachments;
                action(DocAttach)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Category8;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Attachment Document";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
        }
    }

}