class R extends AudioWorkletProcessor{constructor(){super();this.on=false;this.port.onmessage=e=>{this.on=e.data}}
process(inp){const i=inp[0];if(this.on&&i&&i.length){const L=new Float32Array(i[0]);const Rr=new Float32Array(i[1]||i[0]);this.port.postMessage({f:currentFrame,L,R:Rr},[L.buffer,Rr.buffer])}return true}}
registerProcessor('fc-rec',R);
