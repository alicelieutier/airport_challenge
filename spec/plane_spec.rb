require 'plane'

describe Plane do
  describe '#land' do
    it 'expects to be called with one argument' do
      expect(subject).to respond_to(:land).with(1).argument
    end
    it 'asks the airport if landing is possible' do
      airport_double = double(:airport)
      expect(airport_double).to receive(:can_land?)
      subject.land airport_double
    end
    it 'tells the airport that it\'s landing if it was possible' do
      airport_double = double(:airport, :can_land? => true)
      expect(airport_double).to receive(:landing).with(subject)
      subject.land airport_double
    end
    it 'does not tell the airport that it\'s landing if it was not possible' do
      airport_double = double(:airport, :can_land? => false)
      expect(airport_double).not_to receive(:landing)
      subject.land airport_double
    end
    it 'raises an error if the plane has already successfully landed' do
      airport_double = double(:airport, :can_land? => true, :landing => nil)
      subject.land airport_double
      expect{ subject.land airport_double }.to raise_error('Plane has already landed')
    end
  end

  describe '#takeoff' do
    before(:each) do
      airport_double = double(:airport, :can_land? => true, :landing => nil)
      subject.land(airport_double)
    end

    it 'expects to be called with one argument' do
      expect(subject).to respond_to(:takeoff).with(1).argument
    end
    it 'asks the airport if takeoff is possible' do
      airport_double = double(:airport)
      expect(airport_double).to receive(:can_takeoff?)
      subject.takeoff airport_double
    end
    it 'tells the airport that it\'s taking off if it was possible' do
      airport_double = double(:airport, :can_takeoff? => true)
      expect(airport_double).to receive(:takingoff)
      subject.takeoff airport_double
    end
    it 'does not tell the airport that it\'s taking off if it was not possible' do
      airport_double = double(:airport, :can_takeoff? => false)
      expect(airport_double).not_to receive(:takingoff?)
      subject.takeoff airport_double
    end
    it 'raises an error if the plane has already successfully taken off' do
      airport_double = double(:airport, :can_takeoff? => true, :takingoff => nil)
      subject.takeoff airport_double
      expect{ subject.takeoff airport_double }.to raise_error('Plane is already airborne')
    end
  end
  describe '#isAirborne?' do
    it 'returns true for new planes' do
      expect(subject.isAirborne?).to be true
    end
    it 'returns false if the plane has succesfully landed' do
      airport_double = double(:airport, :can_land? => true, :landing => nil)
      subject.land(airport_double)
      expect(subject.isAirborne?).to be false
    end
    it 'returns true if the plane couldn\'t land' do
      airport_double = double(:airport, :can_land? => false)
      subject.land(airport_double)
      expect(subject.isAirborne?).to be true
    end
    it 'returns true if the plane has taken off' do
      airport_double = double(:airport, :can_land? => true, :can_takeoff? => true, :landing => nil, :takingoff => nil)
      subject.land(airport_double)
      subject.takeoff(airport_double)
      expect(subject.isAirborne?).to be true
    end
    it 'returns false if the plane couldn\'t take off' do
      airport_double = double(:airport, :can_land? => true, :can_takeoff? => false, :landing => nil, :takingoff => nil)
      subject.land(airport_double)
      subject.takeoff(airport_double)
      expect(subject.isAirborne?).to be false
    end
  end
end
