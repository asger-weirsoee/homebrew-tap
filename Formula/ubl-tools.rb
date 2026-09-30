class UblTools < Formula
  desc "Read UBL e-invoices (Peppol BIS 3.0, OIOUBL) offline and save their attachments"
  homepage "https://gitea.weircon.dk/agw/ubl-tools"
  url "https://gitea.weircon.dk/agw/ubl-tools/archive/v0.2.0.tar.gz"
  sha256 "a6f4742db202661262f1bae66737417989c98b00ab5b4e7e4c64254f5e99f763"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # A made-up invoice, just enough to prove the binary reads UBL.
    (testpath/"invoice.xml").write <<~XML
      <Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
       xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
        <cbc:ID>BREW-1</cbc:ID>
        <cbc:DocumentCurrencyCode>DKK</cbc:DocumentCurrencyCode>
        <cac:AccountingSupplierParty><cac:Party><cac:PartyName><cbc:Name>Test Seller</cbc:Name></cac:PartyName></cac:Party></cac:AccountingSupplierParty>
        <cac:LegalMonetaryTotal><cbc:PayableAmount currencyID="DKK">125.00</cbc:PayableAmount></cac:LegalMonetaryTotal>
      </Invoice>
    XML
    output = shell_output("#{bin}/ubl view --lang en --no-color #{testpath}/invoice.xml")
    assert_match "BREW-1", output
    assert_match "125.00 DKK", output
    assert_match "<!doctype html>", shell_output("#{bin}/ubl view --html #{testpath}/invoice.xml").downcase
  end
end
