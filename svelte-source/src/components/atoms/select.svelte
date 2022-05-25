<script lang="ts">
  import Select from "svelte-select";

  export let valuesArray: Array<any> = [""]
  export let handleSelectFunction: (val) => void = (val) => null;
  export let value: any = null;
  export let placeHolder: string = "Search...";
  export let virtualList: boolean = false;

  function handleSelect(event) {
    handleSelectFunction(event.detail.value);
  }

</script>

<div class="themed text-white text-base">
  <Select items={valuesArray} labelIdentifier={"value"} {value} on:select={handleSelect} placeholder={placeHolder} isVirtualList={virtualList}/>
</div>

<style>
  .themed {
    --background: #292929;
    --listBackground: #292929;
    --itemIsActiveBG: var(--ps-primary);
    --itemIsActiveColor: black;
    --itemHoverBG: var(--ps-primary-hover);
    --border: #171717;
    --placeholderColor: #ffffff;
    --inputColor: #ffffff;
    --inputFontSize: 1rem;
    --clearSelectFocusColor: var(--ps-primary);
    --clearSelectColor: var(--ps-primary);
    --clearSelectHoverColor: var(--ps-primary);
    --listEmptyColor: #ffffff;
  }
  :global(.selectContainer > *) {
    cursor: pointer !important;
  }
  :global(.listItem > *) {
    cursor: pointer !important;
  }
  :global(.listContainer) {
    z-index: 3 !important;
  }
</style>