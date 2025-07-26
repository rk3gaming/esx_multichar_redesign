<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { fetchNui } from '../utils/fetchNui';
  
  export let isOpen: boolean = false;
  export let characterName: string = '';
  
  const dispatch = createEventDispatcher<{
    close: void;
    spawn: { location: string };
  }>();

  let spawnLocations = [
    { name: 'Legion Square' },
    { name: 'Motel' },
    { name: 'Beach' },
    { name: 'Airport' },
    { name: 'Last Location' }
  ];

  fetchNui('getSpawnLocations').then((locations: any) => {
    if (locations) {
      spawnLocations = locations.map((loc: any) => ({ name: loc.label }));
    }
  });

  $: locationPairs = spawnLocations.slice(0, -1).reduce((acc, curr, i) => {
    if (i % 2 === 0) {
      acc.push([curr]);
    } else {
      acc[acc.length - 1].push(curr);
    }
    return acc;
  }, [] as typeof spawnLocations[]);
  $: lastLocation = spawnLocations[spawnLocations.length - 1];

  function handleSpawn(location: string) {
    fetchNui('spawnAtLocation', { location })
        .then(() => {
            dispatch('close');
        })
        .catch(error => {
            console.error('Error spawning:', error);
        });
  }

  function handleClose() {
    dispatch('close');
  }
</script>

{#if isOpen}
  <div 
    class="modal-backdrop" 
    on:click={e => e.target === e.currentTarget && handleClose()}
    role="button"
    tabindex="0"
    on:keydown={e => e.key === 'Escape' && handleClose()}
  >
    <div class="modal">
      <div class="modal-header">
        <div class="header-content">
          <div class="icon-container">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
            </svg>
          </div>
          <div class="header-text">
            <h2>Select Spawn Location</h2>
            <p class="subtitle">Choose where to spawn {characterName}</p>
          </div>
        </div>
      </div>
      
      <div class="modal-content">
        <div class="spawn-grid">
          {#each locationPairs as pair}
            <div class="spawn-row">
              {#each pair as location}
                <button 
                  class="spawn-option" 
                  on:click={() => handleSpawn(location.name)}
                >
                  <span class="spawn-name">{location.name}</span>
                </button>
              {/each}
            </div>
          {/each}
          <div class="spawn-row single">
            <button 
              class="spawn-option" 
              on:click={() => handleSpawn(lastLocation.name)}
            >
              <span class="spawn-name">{lastLocation.name}</span>
            </button>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button class="cancel-button" on:click={handleClose}>Cancel</button>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.85);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    border: none;
    padding: 0;
    cursor: default;
  }

  .modal {
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 8px;
    width: 720px;
    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.5);
  }

  .modal-header {
    padding: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .header-content {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .icon-container {
    width: 48px;
    height: 48px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: rgba(255, 255, 255, 0.5);
  }

  .header-text {
    color: white;
  }

  .header-text h2 {
    margin: 0;
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
    font-size: 18px;
    font-weight: 600;
  }

  .subtitle {
    margin: 4px 0 0 0;
    color: rgba(255, 255, 255, 0.5);
    font-family: 'Poppins', sans-serif;
    font-size: 13px;
  }

  .modal-content {
    padding: 20px;
  }

  .spawn-grid {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .spawn-row {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }

  .spawn-row.single {
    grid-template-columns: 1fr;
  }

  .spawn-option {
    width: 100%;
    text-align: left;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    padding: 16px;
    display: flex;
    align-items: center;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .spawn-option:hover {
    background: rgba(255, 255, 255, 0.04);
    border-color: rgba(255, 255, 255, 0.1);
  }

  .spawn-name {
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    font-weight: 500;
  }

  .modal-footer {
    padding: 16px 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    gap: 12px;
    justify-content: flex-end;
  }

  .cancel-button {
    padding: 8px 16px;
    border-radius: 6px;
    font-family: 'Poppins', sans-serif;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.7);
  }

  .cancel-button:hover {
    background: rgba(255, 255, 255, 0.04);
    border-color: rgba(255, 255, 255, 0.15);
  }
</style> 