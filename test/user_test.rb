class UserTest
  describe UserTest do
    subject { User.new('usuarium', 'p4ssw0rd') }

    context 'on creation' do
      it 'must be true' do
        expect(subject).to_not be nil
      end

      it 'should got a name attribute' do
        expect(subject.name).to eq 'usuarium'
      end

      it 'can check for valid password ' do
        expect(subject.class.validate_password(subject.name, 'p4ssw0rd')).to be true
        expect(subject.class.validate_password(subject.name, 'notMyPassword')).to be false
        expect(subject.class.validate_password(subject.name, '')).to be false
      end

      it 'must be hard-saved' do
        expect(User.bault).to have_key(:usuarium)
      end
    end
  end
end
