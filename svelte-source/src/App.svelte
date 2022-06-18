<script lang="ts">
  import { fade } from 'svelte/transition';
  import { EventHandler } from './utils/eventHandler';
  import ObjectStore from './stores/objectStore';
  import debug from './stores/debugStore';
  import Tab from './components/atoms/tab.svelte';
  import CreatePanel from './components/panels/create.svelte';
  import ManagePanel from './components/panels/manage.svelte';

  EventHandler();
  document.onkeyup = ObjectStore.handleKeyUp;

  interface tabType {
    name: string
    content: any
  }

  let { isOpen } = ObjectStore;

  let tabArray: Array<tabType> = [
    { name: "Create", content: CreatePanel },
    { name: "Manage", content: ManagePanel },
  ];
  let activeTab: tabType = tabArray[0];

  function handleClick(index: number) {
    activeTab = tabArray[index];
  }
</script>

{#if $isOpen || debug}
  <main class="min-h-screen flex justify-center items-center {debug ? "bg-dark-300":""}" transition:fade="{{duration: 200}}">
    <div class="bg-dark-100 text-white w-[820px] h-[550px] p-5 text-lg rounded-lg shadow-xl my-auto font-semibold select-none">
      <div class="flex flex-row gap-2 mb-5">
        {#each tabArray as tab, i}
          <Tab name={tab.name} on:click={() => handleClick(i)} active={tab.name == activeTab.name}/>
        {/each}
      </div>
      <div class="flex flex-col">
        {#each tabArray as tab}
          {#if activeTab.name == tab.name }
            <svelte:component this={tab.content}/>
          {/if}
        {/each}
      </div>
    </div>
  </main>
{/if}
