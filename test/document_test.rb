class DocumentTest < Document
  describe Document do
    subject { Document.new('someFile', 'Bazinga!') }

    context 'on creation' do
      it 'must be true' do
        expect(subject).to_not be nil
      end

      it 'must have a content' do
        expect(subject.content).to eq 'Bazinga!'
      end

      it 'must have a filename' do
        expect(subject.filename).to eq 'someFile'
      end

      it 'must have a parent folder' do
        expect(subject.parent_folder).to_not be nil
      end
    end

    context 'on edit' do
      it 'must save text on disk' do
        subject.content = 'Bazinga editado'
        subject.save
        expect(subject.location.disk[:drive][:content]).to eq 'Bazinga editado'
      end
    end

    context 'reading metadata' do
      it 'must be not nil' do
        expect(subject.metadata).to_not be nil
      end

      it 'must have some info' do
        metadata = "Size: 8 characters, Created at: #{Time.now}."
        expect(subject.metadata).to eq metadata
      end
    end
  end
end
