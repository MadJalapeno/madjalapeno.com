const Toggle = () => {
    useEffect(() => {
      /* Sets the data-theme attribute on html tag */
      document.documentElement.setAttribute(
        "data-theme",
        localStorage.getItem("theme") === "dark" ? "dark" : "fire"
      );
      console.log ("theme use");
    }, []);
  
    return (
       /* Component provided by daisyUI - https://daisyui.com/components/toggle/ */
       <input
         type="checkbox"
         className="toggle"
         defaultChecked={
           typeof window !== "undefined" &&
           localStorage.getItem("theme") === "dark"
         }
         onClick={(e) => {
           let newTheme = e.target.checked ? "dark" : "fire";
           localStorage.setItem("theme", newTheme);
           document.documentElement.setAttribute("data-theme", newTheme);
           console.log("theme clicked")
          }}
       />
    );
  };
  