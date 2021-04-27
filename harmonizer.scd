


s.boot;
s.latency=0.2;
(


var on, off, keys, vox;


MIDIClient.init;
MIDIIn.connectAll;


keys = Array.newClear(49);




on = MIDIFunc.noteOn({ |veloc, num, chan, src|
	/*keys[num] = Synth(\autotune);
	keys[num].set(\note,num);
	*/
	num.postln;
	keys[num-36] = {
		var in = LPF.ar(HPF.ar(SoundIn.ar(0),100),800);
		var freq = Tartini.kr(in)[0];
		LPF.ar(PitchShiftPA.ar(
			in,
			freq, //pitch tracking - we take just the frequency
			(num.midicps / freq), //pitchRatio
			1, //formantRatio
		),20000).dup
	}.play

	//if(num<=25,{s.record();});

});

off = MIDIFunc.noteOff({ |veloc, num, chan, src|
	keys[num-36].free;
	keys[num-36]=0

});



SynthDef(\vox, { |out|
	var in,lp,chain;
	in = SoundIn.ar(1,0.9);
	lp=LPF.ar(in, 1500);

	lp=HPF.ar(lp, 200);



	Out.ar(0, lp.dup);
}).add;


SynthDef(\autotune, {

	|note=48|
	var in, freq, hasFreq,out,lp;
	var mul=1;
	in=SoundIn.ar(1,0.3);
	lp=HPF.ar(in, 300);
	# freq, hasFreq = Tartini.kr(in);

	freq = Clip.ar(freq, 40.midicps, 70.midicps);
	mul=hasFreq>0.5;

	out = PitchShift.ar(
		in,
		0.1,
		(note.midicps / freq),
		0
		,
		// 0.01,mul/(freq/1000)
	) * 1;



		//PitchShiftPA(lp,freq,(note.midicps / freq),1,10)


	Out.ar(0, out.dup);
}).add;


vox = Synth(\vox);

)

s.prepareForRecord; // if you want to start recording on a precise moment in time, you have to call this first.

s.record(); // start recording. This can also be called directly, if it isn't imprtant when precisely you need to start.

s.pauseRecording; // pausable

s.record // start again
(
vox.free;
)

x.free;






