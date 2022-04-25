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
        expect(subject.validate_password?('p4ssw0rd')).to be true
        expect(subject.validate_password?('notMyPassword')).to be false
        expect(subject.validate_password?('')).to be false
      end

      it 'must be hard-saved' do
        expect(User.bault).to have_key(:usuarium)
      end
    end
  end
end
