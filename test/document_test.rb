class DocumentTest
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
        expect(Document.location.disk[:drive][:someFile][:content]).to eq 'Bazinga editado'
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

    context 'querying' do
      it 'must return document content' do
        expect(subject.class.location.gimme_a_file('someFile')).to eq 'Bazinga!'
      end

      it 'must be available each document from a folder' do
        subject.class.new 'nombre2', 'contenido2'
        subject.class.new 'nombre3', 'contenido3'
        expect(subject.class.location.gimme_a_file('nombre2')).to eq 'contenido2'
        expect(subject.class.location.gimme_a_file('nombre3')).to eq 'contenido3'
      end

      it 'must be possible to fetch files from different folders' do
        subject.class.location.create_folder('carpeta2')
        subject.class.new 'nombre3', 'contenido3'
        expect(subject.class.location.gimme_a_file('nombre3')).to eq 'contenido3'
        expect(subject.class.location.gimme_a_file('someFile')).to eq nil
        subject.class.location.cd '..'
        expect(subject.class.location.gimme_a_file('someFile')).to eq 'Bazinga!'
      end

      it 'must be able to read metadata from filename' do
        metadata = "Size: 8 characters, Created at: #{Time.now}."
        expect(subject.class.location.gimme_a_file('someFile', 'metadata')).to eq metadata
      end
    end

    context 'on destroy' do
      it 'must delete document' do
        expect do
          subject.class.new 'Borrame!', 'contenido'
          expect(subject.class.location.gimme_a_file('Borrame!')).to eq 'contenido'
          subject.class.destroy('Borrame!')
        end.to_not change { Document.location }
        expect(subject.class.location.gimme_a_file('Borrame!')).to be nil
      end
    end
  end
end
