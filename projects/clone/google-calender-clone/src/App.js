import logo from './logo.svg';
import './App.css';
import { getMonth} from "./util"
import CalendarHeader from "./components/CalendarHeader.js";
import Sidebar from "./components/Sidebar";
import Month from "./components/Month";
// import GlobalContext from "./context/GlobalContext";
import EventModal from "./components/EventModal";
import React, { useState, useContext, useEffect } from "react";

function App() {
  const [currenMonth, setCurrentMonth] = useState(getMonth());
  // const { monthIndex, showEventModal } = useContext(GlobalContext);

  return (
    <React.Fragment>
      <div className="h-screen flex flex-col">
        <CalendarHeader />
        <div className="flex flex-1">
          <Sidebar />
          <Month month={currenMonth} />
        </div>
      </div>
    </React.Fragment>
  );
}

export default App;
