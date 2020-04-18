pageextension 50020 "Transfer Order Card" extends "Transfer Order"
{
    layout
    {
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
    var
        ItemJournalPostingCodeUnitG: Codeunit "General Ledger Posting";

}