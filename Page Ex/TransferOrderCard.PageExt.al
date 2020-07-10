pageextension 50020 "Transfer Order Card" extends "Transfer Order"
{

    layout
    {
        addafter(Status)
        {
            field("Total Unit Cost"; "Total Unit Cost")
            {
                ApplicationArea = all;
                ToolTip = 'Total Unit Cost';
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        addafter(Post)
        {// Add changes to page actions here
            action("Create Item Journal")
            {
                Caption = 'Create Item Journal';
                ApplicationArea = all;
                ToolTip = 'Table field';
                Image = Process;
                Enabled = true;
                trigger OnAction()
                begin
                    ItemJournalPostingCodeUnitG.TransferOrderToItemJournal(Rec);
                end;
            }
        }
    }
    //Suraj 23/06/2020
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Error('You cannot insert the record');
    end;

    var
        ItemJournalPostingCodeUnitG: Codeunit "General Ledger Posting";

}