<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();

  let isVisible = false;
  export let playerName = "John Doe";
  export let playerAge = 25;
  export let playerSex = "Male";
  export let playerHeight = 180;

  export function show() {
    isVisible = true;
  }

  function handleClose() {
    isVisible = false;
    dispatch('close');
  }
</script>

{#if isVisible}
  <div class="examine-box">
    <button 
      class="close-button"
      on:click={handleClose}
      aria-label="Close examine window"
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
        <g fill="none" stroke="#808080" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
          <path stroke-dasharray="20" stroke-dashoffset="20" d="M21 3v18">
            <animate fill="freeze" attributeName="stroke-dashoffset" dur="0.13s" values="20;0" />
          </path>
          <path stroke-dasharray="16" stroke-dashoffset="16" d="M3 12h13.5">
            <animate fill="freeze" attributeName="stroke-dashoffset" begin="0.195s" dur="0.13s" values="16;0" />
          </path>
          <path stroke-dasharray="12" stroke-dashoffset="12" d="M17 12l-7 7M17 12l-7 -7">
            <animate fill="freeze" attributeName="stroke-dashoffset" begin="0.325s" dur="0.13s" values="12;0" />
          </path>
        </g>
      </svg>
    </button>
    <div class="top-section">
      <div class="icon-container">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
          <path fill="#fff" d="M16.5 19q1.05 0 1.775-.725T19 16.5t-.725-1.775T16.5 14t-1.775.725T14 16.5t.725 1.775T16.5 19m5.8 3.3q-.275.275-.7.275t-.7-.275l-2-2q-.525.35-1.137.525T16.5 21q-1.875 0-3.187-1.312T12 16.5t1.313-3.187T16.5 12t3.188 1.313T21 16.5q0 .65-.175 1.263T20.3 18.9l2 2q.275.275.275.7t-.275.7M5 22q-.825 0-1.412-.587T3 20V4q0-.825.588-1.412T5 2h7.175q.4 0 .763.15t.637.425l4.85 4.85q.275.275.425.638t.15.762v.45q0 .45-.363.725t-.812.15q-.325-.075-.65-.113T16.5 10q-2.95 0-4.75 2t-1.8 4.525q0 1.1.388 2.175t1.212 2.025q.35.375.162.825t-.637.45zm7-18v4q0 .425.288.713T13 9h4zl5 5z" />
        </svg>
      </div>
      <div class="text-content">
        <h1>Examining</h1>
        <p>You are examining {playerName}</p>
      </div>
    </div>
    <div class="divider"></div>
    <div class="content-section">
      <div class="info-group">
        <div class="info-label">Name</div>
        <div class="info-value">{playerName}</div>
      </div>
      <div class="info-group">
        <div class="info-label">Age</div>
        <div class="info-value">{playerAge}</div>
      </div>
      <div class="info-group">
        <div class="info-label">Sex</div>
        <div class="info-value">{playerSex}</div>
      </div>
      <div class="info-group">
        <div class="info-label">Height</div>
        <div class="info-value">{playerHeight} cm</div>
      </div>
    </div>
  </div>
{/if}

<style>
  .examine-box {
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    color: white;
    padding: 1.5rem 2rem 2rem 2rem;
    border-radius: 8px;
    width: 500px;
    height: 550px;
    margin: 2rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    position: fixed;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    border: 1px solid rgba(255, 255, 255, 0.1);
  }

  .close-button {
    position: absolute;
    top: 1rem;
    right: 1rem;
    background: none;
    border: none;
    padding: 0.5rem;
    cursor: pointer;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
  }

  .close-button:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .close-button:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .close-button svg {
    width: 20px;
    height: 20px;
  }

  .top-section {
    display: flex;
    align-items: flex-start;
    gap: 1.5rem;
    margin-bottom: 1.2rem;
  }

  .divider {
    height: 1px;
    background: rgba(255, 255, 255, 0.1);
    margin: 0 -2rem 1.2rem -2rem;
  }

  .content-section {
    padding: 0.5rem 0;
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }

  .icon-container {
    padding: 1.2rem;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
  }

  .icon-container svg {
    display: block;
    width: 28px;
    height: 28px;
  }

  .text-content {
    padding-top: 0;
  }

  .text-content h1 {
    font-size: 1.5rem;
    font-weight: 600;
    margin: 0 0 0.4rem 0;
    color: white;
  }

  .text-content p {
    margin: 0;
    color: rgba(255, 255, 255, 0.7);
    font-size: 0.9rem;
    line-height: 1.4;
  }

  .info-group {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
  }

  .info-label {
    font-size: 0.8rem;
    color: rgba(255, 255, 255, 0.5);
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .info-value {
    font-size: 1rem;
    color: white;
    line-height: 1.5;
    font-weight: 400;
  }
</style>
