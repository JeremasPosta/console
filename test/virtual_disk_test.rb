class VirtualDiskTest < VirtualDisk
  describe VirtualDisk do
    subject { VirtualDisk.new(:~) }

    context 'on creation' do
      it 'must be true' do
        expect(subject).to_not be nil
      end

      it 'should got a disk attribute' do
        expect(subject.disk).to eq({ '~': {} })
      end
    end

    context 'adding folder' do
      it 'return new structure' do
        subject.create_folder('folderName')
        expect(subject.disk).to eq({ '~': { 'folderName': {} } })
      end

      it 'twice return new nested structure' do
        subject.create_folder('folderName')
        subject.create_folder('nestedName')
        expect(subject.disk).to eq({ '~': { 'folderName': { 'nestedName': {} } } })
      end

      it 'cant add a dot in folder name' do
        expect(subject.create_folder('.')).to eq VirtualDisk::ERRORS[:bad_folder_name]
      end

      it 'cant add a slash in folder name' do
        expect(subject.create_folder('/')).to eq VirtualDisk::ERRORS[:bad_folder_name]
        expect(subject.create_folder('\\')).to eq VirtualDisk::ERRORS[:bad_folder_name]
      end
    end

    context 'navigation' do
      it 'should know its position' do
        subject.create_folder('folderName')
        expect(subject.whereami).to eq '~/folderName'
        subject.create_folder('extraFolderName')
        expect(subject.whereami).to eq '~/folderName/extraFolderName'
      end

      it 'should can exit a folder' do
        subject.create_folder('folderName')
        subject.create_folder('extraFolderName')
        subject.cd('..')
        expect(subject.whereami).to eq '~/folderName'
      end

      it 'should can enter into an existing folder' do
        subject.create_folder('folderName')
        subject.create_folder('extraFolderName')
        subject.cd('..')
        subject.cd('extraFolderName')
        expect(subject.whereami).to eq '~/folderName/extraFolderName'
      end

      it 'cant enter an unexisting folder' do
        subject.create_folder('folderName')
        subject.create_folder('extraFolderName')
        subject.cd('..')
        expect(subject.cd('imInevitable')).to eq VirtualDisk::ERRORS[:unexisting_folder]
        expect(subject.whereami).to eq '~/folderName'
      end
    end
  end
end
