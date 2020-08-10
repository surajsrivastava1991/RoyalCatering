xmlport 50000 "PDC Export"
{
    Direction = Export;
    Format = xml;
    UseDefaultNamespace = true;
    UseRequestPage = false;
    schema
    {
        textelement(PDCList)
        {
            tableelement("PDCEntry"; "PDC Entry")
            {
                fieldelement(DocumentNo; "PDCEntry"."Document No.")
                {

                }
                fieldelement(CreatedDate; PDCEntry."Created Date")
                {

                }
                fieldelement(MaturityDate; PDCEntry."Check Maturity Date")
                {

                }
                fieldelement(A; PDCEntry."Check Amount")
                {

                }
                fieldelement(d; PDCEntry."Customer No./Vendor No.")
                {

                }
                fieldelement(e; PDCEntry."Customer/Vendor Name")
                {

                }
                fieldelement(r; PDCEntry.Amount)
                {

                }
                fieldelement(g; PDCEntry."Jouranl Type")
                {

                }
                fieldelement(l; PDCEntry.Template)
                {

                }
                fieldelement(k; PDCEntry."Batch No.")
                {

                }
                fieldelement(o; PDCEntry."Bank Account No.")
                {

                }
                fieldelement(s; PDCEntry."Bank Account Name")
                {

                }
                fieldelement(b; PDCEntry."PDC Status")
                {

                }
                fieldelement(z; PDCEntry."Entry Posted")
                {

                }
            }
        }
    }
}