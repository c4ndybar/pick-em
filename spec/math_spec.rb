require 'math'

RSpec.describe Math do
  subject { Math.median(@array) }

  it "returns 0 for empty array" do
    @array = []

    expect(subject).to eq(0)
  end

  it "returns 1 for array [1]" do
    @array = [1]

    expect(subject).to eq(1)
  end

  it "returns 1 for array [1,1]" do
    @array = [1,1]

    expect(subject).to eq(1)
  end

  it "returns 1 for array [1,1,1]" do
    @array = [1,1,1]

    expect(subject).to eq(1)
  end

  it "returns 2 for array [1,3]" do
    @array = [1,3]

    expect(subject).to eq(2)
  end

  it "returns 2 for array [1,2,3]" do
    @array = [1,2,3]

    expect(subject).to eq(2)
  end

  it "returns 1.5 for array [1,2]" do
    @array = [1,2]

    expect(subject).to eq(1.5)
  end

  it "returns 2 for array [3,1,2]" do
    @array = [1,2,3]

    expect(subject).to eq(2)
  end

  it "raises error if input is not array" do
    @array = 1

    expect {subject}.to raise_exception(ArgumentError)
  end

  it "raises error if input is nil" do
    @array = nil

    expect {subject}.to raise_exception(ArgumentError)
  end

end