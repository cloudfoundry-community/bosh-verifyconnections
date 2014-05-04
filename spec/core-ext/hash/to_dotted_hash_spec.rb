describe "Hash#to_dotted_hash" do
  it { expect({}.to_dotted_hash).to eq({}) }
  it { expect({"foo" => "bar"}.to_dotted_hash).to eq({"foo" => "bar"}) }
  it { expect({foo: "bar"}.to_dotted_hash).to eq({"foo" => "bar"}) }
  it { expect({foo: {bar: "baz"}}.to_dotted_hash).to eq({"foo.bar" => "baz"}) }

  context "arrays" do
    it { expect({foo: {bar: []}}.to_dotted_hash).to eq({}) }
    it { expect({foo: {bar: ["a", "b"]}}.to_dotted_hash).to eq({"foo.bar[0]" => "a", "foo.bar[1]" => "b"}) }
    it { expect({foo: [{bar: "baz"}, {alpha: 123}]}.to_dotted_hash).to eq({"foo[0].bar" => "baz", "foo[1].alpha" => 123}) }
  end
end
