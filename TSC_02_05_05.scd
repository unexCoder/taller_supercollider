// modulacion de fase con modulador ajustado por "ratio"

(
{ // carrier y modulador
	r = Impulse.kr(10);
	c = TRand.kr(100, 5000, r);
	m = TRand.kr(100, 5000, r);
	PMOsc.ar(c, m, 12)*0.3
}.play
)

(
{
	var rate = 4, carrier, modRatio; // declara variables
	carrier = LFNoise0.kr(rate) * 500 + 700;
	modRatio = MouseX.kr(1, 2.0);
	// modularor expresado como "ratio", influye en el timbre
	PMOsc.ar(carrier, carrier*modRatio, 12)*0.3
}.play
)

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

{SinOsc.ar}.play // genera  temp__reallyLongNumber name

// nombrar funciones de audio "synth" y especificar bus de salida explicitamente
SynthDef("sine", {Out.ar(0, SinOsc.ar)}).play

SynthDef("sine", {Out.ar(1, SinOsc.ar)}).play // canaal derecho

// o

(
SynthDef("one_tone_only", {
	var out, freq = 440;
	out = SinOsc.ar(freq);
	Out.ar(0, out)
}).play
)

// play it!

Synth("one_tone_only");

/////////////

(
SynthDef("different_tones", {
	arg freq = 440; // declara un argumento y le da un valor inicial
	var out;
	out = SinOsc.ar(freq)*0.3;
	Out.ar(0, out)
}).play
)

/////////////

// ejecutar una sentencia por vez

Synth("different_tones", ["freq", 550]);

Synth("different_tones", [\freq, 660]); // igual a "freq"

Synth("different_tones", ["freq", 880]);

// si ningun argumento es explicitado, el synth usa el valor por defecto (440)
Synth("different_tones")

/////////////

a = Synth("different_tones", ["freq", 64.midicps]);

b = Synth("different_tones", ["freq", 67.midicps]);

c = Synth("different_tones", ["freq", 72.midicps]);

a.set("freq", 65.midicps);

c.set("freq", 71.midicps);

a.set("freq", 64.midicps); c.set("freq", 72.midicps);

a.free;

b.free;

c.free;

///////////// Synth definition

(
// synthdef
SynthDef("PMCrotale", {
arg midi = 60, tone = 3, art = 1, amp = 0.8, pan = 0;
var env, out, mod, freq;

freq = midi.midicps;
env = Env.perc(0, art);
mod = 5 + (1/IRand(2, 6));

out = PMOsc.ar(freq, mod*freq,
	pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
	mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

out = Pan2.ar(out, pan);

out = out * EnvGen.kr(env, timeScale: 1.3*art,
	levelScale: Rand(0.1, 0.5), doneAction:2);
Out.ar(0, out); //Out.ar(bus, out);

}).add;
)

// ejecutar varias veces

Synth("PMCrotale", ["midi", rrand(48, 72).round(1), "tone", rrand(1, 6)])


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

// BUFERS


~houston = Buffer.read(s, "sounds/a11wlk01-44_1.aiff");

~chooston = Buffer.read(s, "sounds/a11wlk01.wav");

{PlayBuf.ar(1, ~houston)}.play; // numero de canales y buffer

{PlayBuf.ar(1, ~chooston)}.play;

///////////// Play buffers

[~houston.bufnum, ~houston.numChannels, ~houston.path, ~houston.numFrames];

[~chooston.bufnum, ~chooston.numChannels, ~chooston.path, ~chooston.numFrames];


// Come Out - Steve Reich
(  // phase
{
	var rate, trigger, frames;
	frames = ~houston.numFrames; // ~chooston.numFrames

	rate = [1, 1.01];
	trigger = Impulse.kr(rate);
	PlayBuf.ar(1, ~houston, 1, trigger, frames * Line.kr(0, 1, 60)) *
	EnvGen.kr(Env.linen(0.01, 0.96, 0.01), trigger) * rate;
}.play;
)

/////////////

(  // control de velocidad y dirección
{
	var speed, direction;
	speed = LFNoise0.kr(12) * 0.2 + 1;
	direction = LFClipNoise.kr(1/3);
	PlayBuf.ar(1, ~houston, (speed * direction), loop: 1);
}.play;
)

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// BUSES

///////////// conección de controles mediante buses



(
// mientras un bus no haya sido utilizado el mismo contendra solamente 0's
~kbus1 = Bus.control; // control bus
~kbus2 = Bus.control; // control bus
{
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	PlayBuf.ar(1, ~chooston, (speed * direction), loop: 1);
}.play;
)

(
// Iniciar controles
{Out.kr(~kbus1, LFNoise0.kr(12))}.play;

{Out.kr(~kbus2, LFClipNoise.kr(1/4))}.play;
)

// iniciar el segundo buffer con el mismo bus de entrada de control,
// pero enviado al canal derecho Out.ar(1 etc.

(
{
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	Out.ar(1, PlayBuf.ar(1, ~houston, (speed * direction), loop: 1));
}.play;
)

/////////////

~kbus3 = Bus.control; // control bus

~kbus4 = Bus.control; // control bus

// ejecutar uno por vez

{Out.kr(~kbus3, SinOsc.kr(3).scope("out3") * 100)}.play;

{Out.kr(~kbus4, LFPulse.kr(1/3).scope("out4") * 200)}.play;

{Out.ar(0, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 440).scope("left"))}.play;

{Out.ar(1, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 880).scope("right"))}.play;

~kbus3 = Bus.control; // control bus

~kbus4 = Bus.control; // control bus

{Out.kr(~kbus3, SinOsc.kr(3).range(340, 540))}.play;

{Out.kr(~kbus4, LFPulse.kr(6).range(240, 640))}.play;

SynthDef("Switch", {arg freq = 440; Out.ar(0, SinOsc.ar(freq, 0, 0.3)) }).add;

x = Synth("Switch"); // default

x.map(\freq, ~kbus3)

x.map(\freq, ~kbus4)



///////////// Modulación de un Buffer

(
{
	Out.ar(0,
		Pan2.ar( PlayBuf.ar(1, ~houston, loop: 1) *
			SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600)),
		0.5)
	)
}.play
)

(
{
var source, delay;
	source = PlayBuf.ar(1, ~chooston, loop: 1);
	delay =  AllpassC.ar(source, 2, [0.65, 1.15], 10);
	Out.ar(0,
	Pan2.ar(source) + delay
	)
}.play
)

///////////// ruteo de FX usando buses.

// Creaar y nombrar buses
~delay = Bus.audio(s, 2);
~mod = Bus.audio(s, 2);
~gate = Bus.audio(s, 2);
~k5 = Bus.control;

{Out.kr(~k5, LFNoise0.kr(4))}.play; // iniciar control

// iniciar el ultimo elemento de la cadena de audio, delay
{Out.ar(0, AllpassC.ar(In.ar(~delay, 2), 2, [0.65, 1.15], 10))}.play

// iniciar el elemento anterior, modulation
{Out.ar(~delay, In.ar(~mod, 2) * SinOsc.ar(In.kr(~k5)*500 + 1100))}.play

// iniciar el anterior, gate
{Out.ar([0, ~mod], In.ar(~gate, 2) * max(0, In.kr(~k5)))}.play

// iniciar un buffer
{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~houston, loop: 1), 0.5))}.play;

// iniciar el otro buffer
{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~chooston, loop: 1), -0.5))}.play

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////