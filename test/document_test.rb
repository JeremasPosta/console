class DocumentTest < Document
  describe Document do
    subject {Document.new()}

    context "on creation" do
      it "must be true" do
        expect(subject).to_not be nil
      end
    end
  end
end
