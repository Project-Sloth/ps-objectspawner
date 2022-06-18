<script lang="ts">
	export let value: string = '';
	export let placeholder: string = '';
  export let maxLength: number = 25;

  // bg-gray-50 border border-gray-300 text-gray-900 focus:ring-blue-500 focus:border-blue-500
  //block w-full dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500
  //    dark:focus:border-blue-500"
</script>

	<input
    class="chrome-input bg-[var(--ps-bg)] text-white rounded-sm focus:ring-2 focus:ring-[var(--ps-primary)] ring-blue-200 pl-3 py-2 placeholder-white"
		bind:value
    maxlength={maxLength}
		type="text"
		{placeholder}
	/>

  <style>
    .chrome-input {
      -webkit-appearance: none;
      outline: none;
    }
  </style>