/////////////

a = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B "];

a.at(8);

"Item at index 5 is: ".post; a.at(5).postln; // por que no E?

"Item at index 0 is: ".post; a.at(0).postln; // porque la cuenta comienza de 0

do(50, { [0, 2, 4, 5, 7, 9, 11].at(7.rand).postln})

do(50, { ["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln})

/////////////

Task({
	50.do({
		["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln;
		1.wait;
	});
}).play

/////////////
// Random MIDI walk.

Task({
a = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
"count, midi, pitch, octave".postln;
	do(50, {arg count;
		p = rrand(36, 72);
		[count, p, a.wrapAt(p), (p/12).round(1) - 1].postln;
	1.wait;
	})
}).play

/////////////
// Random Crotale

// usa PMCrotale synthdef
(
a = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
"event, midi, pitch, octave".postln;
r = Task({
	inf.do({ arg count;
		var midi, oct, density;
		density = 1.0; // 100% del tiempo.
		// density = 0.7;
		// density = 0.3;
		midi = [0, 2, 4, 7, 9].choose;
		// midi = [0, 2, 4, 5, 7, 9, 11].choose;
		// midi = [0, 2, 3, 5, 6, 8, 9, 11] .choose;
		// midi = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] .choose;
		oct = [48, 60, 72].choose;
		if(density.coin,
			{ // true action
				"".postln;
				[midi + oct, a.wrapAt(midi),
				(oct/12).round(1)].post;
				Synth("PMCrotale",
					["midi", midi + oct, "tone", rrand(1, 7),
					"art", rrand(0.3, 2.0), "amp", rrand(0.3, 0.6), "pan", 1.0.rand2]);
			}, {["rest"].post}); // false action
		0.2.wait;
	});
}).start
)

r.stop; // stop

/////////////

if(10 == 10, {"10 is indeed equal to 10"}, {"false"})

if((1 < 20).and(1.isInteger), {"1 is less than 20"}, {"false"})

10.do({arg count; [count, if(count.odd, {"odd"}, {"even"})].postln})

(
84.do({arg count; if([0, 4, 7].includes(count%12),
	{count.post; " is part of a C triad.".postln},
	{count.post; " is not part of a C traid".postln})})
)

50.do({if(1.0.rand.round(0.01).post > 0.5,  {" > 0.5".postln}, {" < 0.5".postln})})

50.do({if(1.0.rand > 0.5,  {"play a note".postln}, {"rest".postln})})

50.do({if(0.5.coin, {"play a note".postln}, {"rest".postln})}) // idem

if((10.odd).or(10 < 20), {"true".postln}, {"false".postln})

/////////////

Array.fill(100, {wchoose([1, 2, 3, 4], [0.5, 0.3, 0.125, 0.075])}).sort

/////////////

[0, 2, 4, 5, 7, 9, 11].do({arg each, count; ["count", count, "each", each].postln})
// idem
[0, 2, 4, 5, 7, 9, 11].do({arg whatever, blech; [blech, whatever].postln})

(
var pc;
pc = ["C", "C#", "D",  "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
[0, 2, 4, 5, 7, 9, 11].do({arg each; pc.wrapAt(each).postln;})
)

/////////////
// loops anidados para generar matriz dodecafónica

(
var row, inversion, pitchClass;
row = Array.series(11, 1).scramble.insert(0, 0);
// Webern's Op 27
// row = [0, 11, 8, 2, 1, 7, 9, 10, 4, 3, 5, 6];
row.postln;
inversion = 12 - row;
pitchClass = ["C  ", "C# ", "D  ", "Eb ",
	"E  ", "F  ", "F# ", "G  ", "Ab ", "A  ", "Bb ", "B  "];
inversion.do({arg eachInv;
	var trans;
	trans = (row + eachInv);
	// prints pitch class
	trans.do({arg scaleDegree; pitchClass.wrapAt(scaleDegree).post});
	//"".postln;
	// prints solo numeros
	//trans.do({arg scaleDegree; (scaleDegree%12).post; " ".post});
	"".postln;
	});
"".postln
)

/////////////

{LFNoise1.ar(5000)}.plot // random wave

{max(0, LFNoise1.ar(5000))}.plot // solo valores positivos

(
{
var ampCont;
ampCont = max(0, LFNoise1.kr(12)); // LFO control
SinOsc.ar(440, mul: ampCont)
}.scope
)

/////////////
// ejemplo de síntesis aditiva

// Mixdown algunas sinusoides en relación armónica:

(
{
var fund = 220;
Mix.ar(
	[
	SinOsc.ar(220, mul: max(0, LFNoise1.kr(12))),
	SinOsc.ar(440, mul: max(0, LFNoise1.kr(12)))*1/2,
	SinOsc.ar(660, mul: max(0, LFNoise1.kr(12)))*1/3,
	SinOsc.ar(880, mul: max(0, LFNoise1.kr(12)))*1/4,
	SinOsc.ar(1110, mul: max(0, LFNoise1.kr(12)))*1/5,
	SinOsc.ar(1320, mul: max(0, LFNoise1.kr(12)))*1/6
	]
)*0.3
}.play
)

/////////////
// ejemplo de síntesis aditiva

//
Array.fill(20, {arg cnt; cnt + 1*110});

//
(
{Mix.ar(
	Array.fill(12,
		{arg count;
		var harm;
		harm = count + 1 * 110; // precedencia; count + 1, luego * 110
			SinOsc.ar(harm,
				mul: max([0, 0], SinOsc.kr(count+1/4))
				)*1/(count+1)
		})
)*0.7}.play
)

/////////////
// campanas de modelado físico


Array.fill(3, {Array.fill(10, {rand(1000)})})
//
(
{
var scale, specs, freqs, amps, rings,
	numRes = 5, bells = 20, pan;
scale = [60, 62, 64, 67, 69].midicps;
	Mix.fill(bells, {
		freqs = Array.fill(numRes, {rrand(1, 15)*(scale.choose)});
		amps = Array.fill(numRes, {rrand(0.3, 0.9)});
		rings = Array.fill(numRes, {rrand(1.0, 4.0)});
		specs = [freqs, amps, rings].round(0.01);
		// specs.postln;
		pan = (LFNoise1.kr(rrand(3, 6))*2).softclip;
		Pan2.ar(
			Klank.ar(`specs,
				Dust.ar(1/6, 0.03)),
				pan)
	})
}.play;
)

/////////////
// generación de secuencias usando Arrays

( // synthdef

SynthDef.new("SimpleBlip", {
arg midi = 60, tone = 10, art = 0.125, amp = 0.2, pan = -1;
var out, temper;
out =	Pan2.ar(
			Blip.ar(
				midi.midicps,
				tone
				) * EnvGen.kr(Env.perc(0.01, art)),
		pan
	);
DetectSilence.ar(out, doneAction:2);
amp = amp - ((midi - 60) * 0.02);
Out.ar(0, out*amp)
	}).add;
)

/////////////

(
// Task
~inst = [0, 0, 0]; // 3 containers para tasks
~pSeq = [0, 0, 0]; // 3 containers para sequences
~scaleAdd = [4, 5, 11, nil, 10, 3, 6, nil]; //
~notes =
[" C", " C#", " D", " Eb", " E", " F",
	" F#", " G", " Ab", " A", " Bb", " B"];
~rout = Task({
	inf.do({
		arg cnt1;
		var steps, durSeq, harmSeq;
		steps = rrand(6, 12);
		if(cnt1%6 == 0, // c/6 repeticiones suma un grado
			{~scale = ~scale.add(~scaleAdd.wrapAt((cnt1/6).round(1) - 1));});
		"\nIteration: ".post; cnt1.post;
		[" (center) ", " (right) ", " (left) "].wrapAt(cnt1).postln;
		if(cnt1%24 == 0, // reset
			{~scale = [0, 2, 7, 9];
			3.do({arg cnt2;
				~pSeq.wrapPut(cnt2,
					Array.fill(steps,
						{~scale.choose + [48, 60].choose}))})});
		"scale: ".post; ~scale.postln;
		~pSeq.wrapPut(cnt1, // array escala
			Array.fill(steps, {~scale.choose + [48, 60].choose}));
		"MIDI seq: ".post; (~pSeq.wrapAt(cnt1)%12).postln;
		"Sequence (notes): ".post;
		~pSeq.wrapAt(cnt1).do( // print notas
			{arg thisItem; ~notes.at(thisItem%12).post});
		"".postln;
		// crea arrays armonicos y duraciones
		harmSeq = Array.fill(steps, {rrand(1.0, 5.0)});
		durSeq = Array.fill(steps - 1, {rrand(0.01, 0.9)});
		// stop task previo en este punto
		~inst.wrapAt(cnt1).stop;
		~inst.wrapPut(cnt1,
			Task({
				inf.do({arg cnt3; // cada secuencia
					Synth("SimpleBlip",
						[\midi, ~pSeq.wrapAt(cnt1).wrapAt(cnt3),
						\tone, harmSeq.wrapAt(cnt3),
						\art, durSeq.wrapAt(cnt3),
						\amp, rrand(0.1, 0.3),
						\pan, cnt1.wrap(-1, 2)]);
					0.125.wait; // tempo de cada nota
				})}).start;
		);
		12.wait;})
}).start;
)

~rout.stop; // stop secuencia

~inst.at(0).free;

~inst.at(1).free;

~inst.at(2).free;

/////////////

Server.internal.prepareForRecord; // o Server.local

Server.internal.record;

Server.internal.stopRecording;

// formatos de archivo de grabacion
Server.internal.recSampleFormat = "int16";

Server.internal.recChannels = 1; // default stereo


Server.internal.prepareForRecord("myAudio.aif");

/////////////Offset y scale

(
	{
	var trigger, wave, label, scale, offset;
	trigger = Impulse.kr(10);
	wave = SinOsc.kr(1/10) ; // cambia a 400
	scale = 1; offset = 0;
//	wave = wave * scale + offset;
	label = "scale = " ++ scale.asString ++ ", offset = " ++ offset.asString;
	wave.round(0.01).poll(label: label);
	}.scope(1)
)

/////////////
// SinOsc con offset y escaledo para control

(
	{
	var trigger, control, scale, offset;
	scale = 300; // test otros valores no mayores que offset
	offset = 600; // test otros valores
	trigger = Impulse.kr(10);
	control = SinOsc.ar(1/4).scope("control"); // LFO
	control = control  * scale + offset;
	SinOsc.ar(freq: abs(control).poll).scope("audio")
	}.play
)

// Theremin con vibrato

{SinOsc.ar(SinOsc.ar(8, 0, 10, MouseX.kr(400, 1000, 1)))}.play

/////////////
// Test you skills on a patch

(
{
	var carrier, rate, trigger, modRatio, index, control, env;
	rate = 3;
	trigger = Impulse.kr(rate);
	control = LFNoise0.kr(rate);
	carrier = 62;
	modRatio = 4.125;
	index = 10;
	carrier = carrier.midicps;
	carrier.poll(trigger, "carrier");
	index.poll(trigger, "index");
	modRatio.poll(trigger, "modRatio");
	PMOsc.ar(carrier, carrier*modRatio, index)
}.play
)

/////////////
// PMOsc con offset y scale.

(
a = SynthDef("PMOsc_ex",
{
	arg left = 10, right = 10, indexLow = 4, indexHigh = 12;
	var pitch, timbre, trigger, env, index, out;
	trigger = Impulse.kr([left, right]); // trigger
	pitch = TRand.kr(36, 72, trigger).round(1); // C2 a C6
	timbre = LFNoise0.kr(1/20, mul: 0.2, add: 2); // mod control
	env = Linen.kr(trigger, releaseTime: 1/[left, right]); // envolvente
	index = env * indexHigh + indexLow; // env escalada y con offset para index
	pitch = pitch.midicps; // midi to freq
	out = PMOsc.ar(pitch, pitch*timbre, index, mul: env);
	Out.ar(0, out);
}).play
)

a.set("left", 4)

a.set("right", 5)

a.set("indexLow", 1)

a.set("indexHigh", 4)

/////////////
// PMOsc con "sample and hold" (o latch "cerrojo").

(
// run
a = SynthDef("Latch_demo",
{
arg rate = 9;
var freq, latchrate, index, ratio, env, out;
latchrate = rate*LFNoise0.kr(1/10, mul: 0.03, add: 1.6);
index = Latch.kr(
	LFSaw.kr(latchrate, mul: 5, add: 6),
	Impulse.kr(rate)
	);
freq = Latch.kr(
	LFSaw.kr(latchrate,
	mul: max(0, LFNoise1.kr(1/5, mul: 24, add: 10)),
	add: LFNoise0.kr(1/7, mul: 12, add: 60)),
	Impulse.kr(rate)
	).round(1).midicps;

ratio = LFNoise1.kr(1/10, mul: 2.0, add: 5.0);

env = EnvGen.kr(
	Env.perc(0, LFNoise0.kr(rate, mul: 1, add: 1.5)/rate),
	Impulse.kr(rate),
	LFNoise1.kr([5, 5], 2, 1).max(0).min(0.8));
out = PMOsc.ar(
	[freq, freq * 1.5],
	freq*ratio,
	index,
	mul: env
);
Out.ar(0, out);
}
).play
)

a.set("rate", 10)

a.set("rate", 15)

a.set("rate", 6)

a.free;

/////////////
// campana

(
{ // it's just a bell
var burst, burstEnv, bell, delay, dry,
burstFreq = 500, freqs, amps, rings;
burstEnv = EnvGen.kr(Env.perc(0, 0.05),
				Dust.kr(1/5), 0.1);
// burstEnv.poll(100, "env");
burst = SinOsc.ar(freq: burstFreq,
	mul: burstEnv);
// burst.poll(100, "burst");
freqs = Array.fill(10, {exprand(100, 1000)});
amps = Array.fill(10, {rrand(0.01, 0.1)});
rings = Array.fill(10, {rrand(1.0, 6.0)});
// [freqs, amps, rings].round(0.01).postln;
// valores seguros
// freqs = [100, 200, 300, 400];
// amps = [1, 1, 1, 1];
// rings = [1, 1, 1, 1];

bell = Pan2.ar(
	Klank.ar(`[freqs, amps, rings], burst),
	rrand(-1.0, 1.0)
);

delay = AllpassN.ar(bell, 2.5,
	[LFNoise1.kr(7, 1.5, 1.6), LFNoise1.kr(7, 1.5, 1.6)],
	1, mul: 0.8);
bell + delay
// + SinOsc.ar(mul: LFPulse.kr(1) * 0.05);
}.play
)

