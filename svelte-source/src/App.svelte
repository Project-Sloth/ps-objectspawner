<script lang="ts">
  import { fade } from 'svelte/transition';
  import { EventHandler } from './utils/eventHandler';
  import ObjectStore from './stores/objectStore';
  import NumberInput from './components/atoms/number-input.svelte';
  import Select from './components/atoms/select.svelte';
  import Button from './components/atoms/button.svelte';
  

  EventHandler();
  document.onkeyup = ObjectStore.handleKeyUp;

</script>

{#if $ObjectStore.isOpen}
  <main class="min-h-screen flex justify-center items-center" transition:fade="{{duration: 200}}">
    <div class="bg-dark-100 text-white w-[300px] p-5 text-lg rounded-lg shadow-xl my-auto font-semibold">
      <div class="flex flex-col gap-5 text-center">
        <div class="flex flex-col gap-1">
          <p>Select Object</p>
          <Select valuesArray={$ObjectStore.objectList} handleSelectFunction={(val) => ObjectStore.setObject(val)}/>
        </div>
        <div class="flex flex-col gap-1">
          <p>Render Distance</p>
          <NumberInput min={0} max={100} value={$ObjectStore.renderDistance} handleUpdateFunction={(val) => ObjectStore.setRenderDisable(val)}/>
        </div>
        <div class="flex flex-col gap-1">
          <p>Select Object Type</p>
          <Select valuesArray={$ObjectStore.objectTypes} handleSelectFunction={(val) => ObjectStore.setObjectType(val)}/>
        </div>
        <Button name={"Spawn Object"} buttonClass="w-50 mx-auto" on:click={ObjectStore.spawnObject}/>
      </div>
    </div>
  </main>
{/if}
