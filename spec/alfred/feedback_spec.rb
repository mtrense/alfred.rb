
describe Alfred::Feedback do
	
	context do
		subject { Alfred.feedback { item { title 'Hello' } } }
		
		it { subject.items.should have(1).items }
	end
	
	context do
		subject { Alfred.feedback { item { title 'Hello' } }.to_xml }
		
		it { subject.elements.first.attribute('arg').to_s.should == 'Hello' }
		it { subject.elements.first.elements.select {|e| e.name == 'title' }.first.text.should == 'Hello' }
		it { subject.elements.first.elements.select {|e| e.name == 'subtitle' }.first.text.should == '' }
	end
	
end
