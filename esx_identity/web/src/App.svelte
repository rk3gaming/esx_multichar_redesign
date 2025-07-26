<script lang="ts">
  import Identity from './lib/components/Identity.svelte';
  import Examine from './lib/components/Examine.svelte';

  let examineComponent: Examine;

  function handleExamineClose() {
    // The component handles its own visibility now
  }
</script>

<Identity />
<Examine bind:this={examineComponent} />

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: 'Poppins', sans-serif;
    background: transparent;
    overflow: hidden;
    user-select: none;
  }
</style>
